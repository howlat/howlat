class BasePresenter
  delegate :current_ability, :current_user, :github, :params, to: :h

  def initialize(object, helper, options = {})
    @object = object
    @helper = helper
    @options = {}
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @helper
  end
end
