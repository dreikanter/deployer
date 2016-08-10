module ViewBuilders
  class NavbarMenu < ViewBuilders::Base
    def html
      h.content_tag(:ul, class: navbar_classes) { navbar_items }
    end

    private

    def navbar_items
      menu_items.map { |item| navbar_item(item) }.join.html_safe
    end

    def menu_items
      options[:items] || []
    end

    def navbar_item(item)
      h.content_tag(:li, class: navbar_item_classes(item)) do
        h.link_to(item[:caption], item[:path], item.slice(:target, :method))
      end
    end

    def navbar_classes
      "nav navbar-nav navbar-menu #{options[:class]}".strip
    end

    def navbar_item_classes(item)
      'active' if item[:controller] == current_controller
    end

    def current_controller
      h.controller.controller_name
    end
  end
end
