class ErectorWidgets::BaseWidget < Erector::Widget
 
  private 
  
  def t(text)
    I18n.translate(text)
  end

  def error_messages_for(entities)
    if entities.instance_of? Symbol
      entities = [entities]
    end
    size = 0
    errortext = ""
    first = true
    entities.each do |entity|
      name = "@#{entity.to_s}"
      instance = instance_variable_get(name)
      if instance.errors.size > 0
        size = size + instance.errors.size
        errortext = 
          if first
            first = false
            "#{instance.errors.full_messages.join('<br />')}" 
          else
            "#{errortext}<br />#{instance.errors.full_messages.join('<br />')}"
          end
      end
    end
    
    errortext if size > 0
  end

  def error_message_on(entity, attribute)
    name = "@#{entity.to_s}"
    instance = instance_variable_get(name)
    if instance.errors[attribute.to_sym].size > 0
      rawtext "#{instance.errors[attribute.to_sym].join('<br />')}"
    end
  end

end
