module Admin::EpisodesHelper
  def show_id_form_column(record, input_name)
    collection_select :record, :show_id, Show.find(:all), :id, :name
  end
end
