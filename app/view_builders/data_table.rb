module ViewBuilders
  class DataTable < ViewBuilders::Base
    def html
      records.any? ? table : empty_placeholder
    end

    private

    def default_empty_text
      'No records'
    end

    def columns
      (presenter.columns || []) + optional_columns
    end

    def actions
      presenter.actions
    end

    def optional_columns
      actions.blank? ? [] : [action_column]
    end

    def action_column
      {
        title: '',
        value: -> (r) { action_dropdown(r) },
        classes: 'min-width text-center dropdown'
      }
    end

    def action_dropdown(record)
      action_dropdown_link(record) + action_dropdown_menu(record)
    end

    ELLIPSIS = '<i class="fa fa-ellipsis-h"></i>'.html_safe

    def action_dropdown_link(record)
      h.link_to(ELLIPSIS, '#', action_dropdown_link_attributes(record))
    end

    def action_dropdown_link_attributes(record)
      {
        class: 'dropdown-toggle',
        data: { toggle: :dropdown },
        'aria-haspopup' => 'true',
        'aria-expanded' => 'false',
        id: "action-dropdown-link-#{record.id}"
      }
    end

    def action_dropdown_menu(record)
      h.content_tag(:ul, class: 'dropdown-menu dropdown-menu-right', 'aria-labelledby' => "action-dropdown-link-#{record.id}") do
        action_dropdown_menu_items(record).join.html_safe
      end
    end

    def action_dropdown_menu_items(record)
      actions.map { |a| action_dropdown_menu_item(record, a) }
    end

    def action_dropdown_menu_item(record, action)
      h.content_tag(:li) { action_dropdown_menu_link(record, action) }
    end

    def action_dropdown_menu_link(record, action)
      h.link_to(action[:title], action[:path].call(record),
        action.slice(:remote, :method, :data))
    end

    def table
      h.content_tag :table, class: table_classes do
        [table_header, table_body].join.html_safe
      end
    end

    def table_classes
      'table table-bordered table-hover table-truncate-cells table-sortable data-table'
    end

    def table_header
      h.content_tag :thead do
        h.content_tag(:tr, table_header_cells)
      end
    end

    def table_header_cells
      columns.map { |c| table_header_cell(c) }.join.html_safe
    end

    def table_header_cell(column)
      content = table_header_content(column[:title], column[:order_field])
      h.content_tag(:th, content, table_header_attrs(column))
    end

    def table_header_attrs(column)
      attrs = table_header_tooltip_attrs(column[:title_hint])
      classes = attrs.empty? ? column[:classes] : "#{column[:classes]} hint"
      attrs.merge(class: classes)
    end

    def table_header_tooltip_attrs(title_hint)
      return {} unless title_hint.present?
      data = { toggle: :tooltip }
      { data: data, title: title_hint }
    end

    def table_header_content(title, order_field)
      return title unless order_field
      order_link_to(order_field, title)
    end

    def table_body
      content = records.map { |i| table_row(presented(i)) }.join.html_safe
      h.content_tag(:tbody, content)
    end

    def table_row(record)
      h.content_tag(:tr, table_row_attrs(record)) do
        columns.map { |c| table_cell(c, record) }.join.html_safe
      end
    end

    def table_row_attrs(record)
      {
        data: { id: record.id }
      }
    end

    def table_cell(column, record)
      h.content_tag(
        :td,
        table_cell_value(column[:value], record),
        table_cell_attrs(column, record)
      )
    end

    def table_cell_value(value, record)
      return value.call(record) if value.respond_to?(:call)
      value
    end

    def table_cell_attrs(column, record)
      { data: table_cell_data(column, record), class: column[:classes] }
    end

    def table_cell_data(column, record)
      return unless column[:data].respond_to?(:call)
      column[:data].call(record).map { |k, v| [k.to_s, v.to_s] }.to_h
    end

    def order_link_to(field, title)
      classes = order_link_current?(field) ? 'current' : nil
      title = order_link_title(field, title)
      h.link_to(title, order_link_path(field), class: classes)
    end

    def order_link_title(field, title = nil)
      [title || field.to_s.humanize, order_link_icon(field)].join.html_safe
    end

    def order_link_icon(field)
      return ''.html_safe unless order_link_current?(field)
      h.fa_icon("sort-#{h.params[:order] == 'asc' ? 'asc' : 'desc'}")
    end

    def order_link_path(field)
      order = (h.params[:order] == 'asc') ? :desc : :asc
      h.url_for(controller: h.controller.controller_name,
        action: h.controller.action_name, sort_by: field, order: order)
    end

    def order_link_current?(field)
      h.params[:sort_by] == field.to_s
    end
  end
end
