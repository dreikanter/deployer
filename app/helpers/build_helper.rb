module BuildHelper
  def build(view_builder, options = {})
    "view_builders/#{view_builder}".classify.constantize.new(self, options).html
  end
end
