class ApplicationHelper::Button::MiqAe < ApplicationHelper::Button::Basic
  include MiqAeClassHelper
  needs :@record

  def role_allows_feature?
    role_allows?(:feature => 'miq_ae_domain_edit')
  end

  def disabled?
    @error_message = _('At least one domain should be enabled and unlocked') if !editable_domain?(@record) &&
                                                                                !domains_available_for_copy?
    @error_message.present?
  end

  def visible?
    edit_possible?
  end

  private

  def edit_possible?
    MiqAeClassController::MIQ_AE_COPY_ACTIONS.include?(self[:child_id]) &&
      User.current_tenant.any_editable_domains? &&
      MiqAeDomain.any_unlocked?
  end

  def domains_available_for_copy?
    User.current_tenant.any_editable_domains? &&
      MiqAeDomain.any_unlocked? &&
      MiqAeDomain.any_enabled?
  end
end
