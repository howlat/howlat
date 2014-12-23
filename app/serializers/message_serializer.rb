class MessageSerializer < ApplicationSerializer

  attributes :id, :body, :room_id, :from, :parent_id, :type, :attachment_url,
    :attachment_content_type, :attachment_file_name, :parameters, :tags,
    :attachment_thumb_url, :has_children, :timestamp, :updated_at, :edited_at

  has_one :author, serializer: AuthorSerializer

  def body
    object.body
  end

  def timestamp
  	object.created_at
  end

  def from
  	author.try(:jid)
  end

  def tags
    object.cached_tag_list
  end

end
