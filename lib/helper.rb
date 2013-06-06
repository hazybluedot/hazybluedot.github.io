include Nanoc::Helpers::Tagging
include Nanoc::Helpers::Blogging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering

module PostHelper

  def get_pretty_date(post)
    attribute_to_time(post[:created_at]).strftime('%B %-d, %Y')
  end

  def get_post_start(post)
    content = post.compiled_content
    if content =~ /\s<!-- more -->\s/
      content = content.partition('<!-- more -->').first +
        "<div class='read-more'><a href='#{post.path}'>Continue reading &rsaquo;</a></div>"
    end
    return content
  end

  def image_tag(image)
    content = "<img src='#{image}' />"
  end
end

class YouTubeFilter < Nanoc::Filter
  identifier :youtube
  type :text
  
  def run(content, params={})
#    content.gsub(/[a-z]+/, 'nanoc rules')
    content.each_line.map do |line|
      youtube_id = nil
      if line[/^\s*https?:\/\/youtu\.be\/([^\?]*)/]
        youtube_id = $1
      elsif line[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        youtube_id = $5
      end
      
      if youtube_id
        line  = %Q{<p><iframe title="YouTube video player" width="584" height="329" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe></p>}
      else
        line
      end
    end.join("")
  end
end

include PostHelper
