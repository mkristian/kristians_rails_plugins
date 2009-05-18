class ErectorWidgets::EntityWidget < ErectorWidgets::BaseWidget

  def initialize(view, assigns, *args)
    super(view, assigns, *args)
    @__entity = assigns["#{entity_symbol}"] if entity_symbol
    @__disabled = false
  end

  def disabled=(disabled)
    @__disabled = disabled
  end

  def title
    "please overwrite"
  end

  def render_errors
    if entity_symbol and (errors = error_messages_for(entity_symbol))
      div :class => :errors do
        rawtext errors
      end
    end
  end

  def render
    fieldset :class => :entity do
      legend title

      render_navigation(@__disabled)

      render_timestamps

      render_errors

      if flash[:notice]
        div :class => :message do
          text flash[:notice]
          flash.clear
        end
      end

      render_entity(@__disabled)
    end
  end

  def render_timestamps
    if @__entity and not @__entity.new_record?
      div :class => :timestamps do
        div :class => :first do
          text "created at" + " " + @__entity.created_at.asctime if @__entity.attributes.member? :created_at
        end
        div :class => :second do
          text "updated at" + " " + @__entity.updated_at.asctime if @__entity.attributes.member? :updated_at
        end
      end
    end
  end

  def render_navigation(disabled)
    div nbsp(" "), :class => :nav_buttons
  end
  
  def render_entity(disabled)
  end
end
