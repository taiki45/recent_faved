# -*- coding: utf-8 -*-

Plugin.create :recent_faved do
  start_time = Time.now

  recent_faved = lambda do |msg|
    msg.from_me? && !(msg.favorited_by.empty?) && Time.parse(msg.to_hash[:created_at]) > start_time
  end

  tab :recent_faved, "R" do
    timeline :recent_faved do
      order do |message|
        Time.parse(message.to_hash[:created_at]).strftime("%s").to_i
      end
    end
  end

  on_favorite do |service, user, message|
    if message.from_me?
      timeline(:recent_faved) << message
    end
  end

  on_message_modified do |message|
    timeline(:recent_faved) << message if recent_faved.(message)
  end
end
