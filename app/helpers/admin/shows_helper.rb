module Admin::ShowsHelper  

  def next_show_form_column(record, input_name)
    options = datetime_select("record", "next_show")
    (options + "Enter Time in YOUR TimeZone (#{@time_zone.nil? ? 'UTC' : @time_zone})")
  end
  
  def active_form_column(record, input_name)
    options = check_box(:record, :active)
  	options
  end
  
  def desc_form_column(record, input_name)
  	text_area :record, :desc
  end
  
  def keywords_form_column(record, input_name)
  	text_field :record, :keywords, :class => "text-input"
  end
  
  def show_type_id_form_column(record, input_name)
    collection_select :record, :show_type_id, ShowType.all, :id, :name
  end
  
  def next_show_column(record)
    record.next_show.in_time_zone
  end
end
