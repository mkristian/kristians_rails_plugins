class ErectorWidgets::EntitiesWidget < ErectorWidgets::BaseWidget

  def initialize(view, assigns, *args)
    super(view, assigns, *args)
    @__entities = assigns["#{entities_symbol}"]
  end

  def title
    "please overwrite"
  end

  def render
    fieldset :class => :entities do
      legend title

      render_navigation

      if flash[:notice]
        div :class => :message do
          text flash[:notice]
        end
      end

      table do
        tr do
          render_table_header
        end
        for entity in @__entities
          tr do
            render_table_row(entity)
          end
        end
      end
    end
  end

  def render_navigation
  end
  
  def render_table_header
  end

  def render_table_row(entity)
  end
end
