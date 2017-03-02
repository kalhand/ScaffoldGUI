class <%= plural_class_name %>Controller < ApplicationController
  <%= controller_methods :actions %>

  # Only allow a trusted parameter "white list" through.
  def <%= "#{singular_table_name}_params" %>
    params.require(:<%= instance_name %>).permit(<%= model_attributes.map { |a| ":#{a.name}" }.join(", ") %>)
  end
end
