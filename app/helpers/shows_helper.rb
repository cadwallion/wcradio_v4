module ShowsHelper
  def show_type_name(id)
    if id == 1
      " - A World of Warcraft Podcast"
    else
      " - A WoW Radio Production"
    end
  end
end
