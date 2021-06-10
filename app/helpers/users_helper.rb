module UsersHelper
    def gravatar_for(user, options = {size: 80})
        size = options[:size]
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        puts gravatar_url
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
end
