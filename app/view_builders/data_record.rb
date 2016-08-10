module ViewBuilders
  class DataRecord < ViewBuilders::Base
    def html
      property_groups.join.html_safe
    end

    private

    def property_groups
      presenter.record.map { |g| property_group(g) }
    end

    def property_group(group)
      [
        group_title(group[:title]),
        group_content(group[:properties])
      ].join.html_safe
    end

    def group_title(title)
      h.content_tag(:h2, title, class: 'property-group-title')
    end

    GROUP_TABLE_CLASSES = 'table table-bordered table-hover table-striped'

    def group_content(properties)
      h.content_tag(:table, class: GROUP_TABLE_CLASSES) do
        properties.map { |p| property_row(p) }.join.html_safe
      end
    end

    def property_row(property)
      h.content_tag(:tr) { property_cells(property).join.html_safe }
    end

    def property_cells(property)
      [
        property_title_cell(property[:title]),
        property_value_cell(property[:value])
      ]
    end

    def property_title_cell(title)
      h.content_tag(:td, title, class: 'col-lg-3 property-title')
    end

    def property_value_cell(value)
      h.content_tag(:td, property_value(value), class: 'property_value')
    end

    def property_value(value)
      return value.call(record) if value.respond_to?(:call)
      value
    end
  end
end
