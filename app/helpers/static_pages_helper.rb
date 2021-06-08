module StaticPagesHelper

    def full_title(page_title = '') #if some page do not provide the title, it will be default
        #this func only support for static controller only
        base_title = "Ruby on Rails Tutorial Sample App"

        if page_title.empty?
            base_title
        else
            page_title += " | " + base_title
        end
    end

end
