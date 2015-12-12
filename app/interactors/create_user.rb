class CreateUser
  include Interactor

  def call
    validate_input
    execute
    validate_output
  end

  private

  def validate_input
    context.fail!(error: "invalid user params") unless context.user_params
  end

  def execute
    context.user = User.create!(context.user_params)
  rescue
    context.user = nil
  end

  def validate_output
    context.fail!(error: "invalid user") unless context.user
  end
end
