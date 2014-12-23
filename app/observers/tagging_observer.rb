class TaggingObserver < ActiveRecord::Observer

  def after_save(tagging)
    update_message_index(tagging.message)
  end

  def after_destroy(tagging)
    update_message_index(tagging.message)
  end

  private

  def update_message_index(message)
    message.tire.update_index
  end
end
