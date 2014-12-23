class ChatMessage < Message

  tire.index_name superclass.tire.index_name

  validates :author_id, presence: true
  validates :body, presence: true

  after_commit on: :create do
    NotifyMentioned.perform_async(self.id)
  end

end
