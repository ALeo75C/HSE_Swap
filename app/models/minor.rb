
class Minor < ApplicationRecord
  belongs_to :faculty

  def as_json_for_main_page
    {
      title: title,
      kredits: kredits,
      deskription: deskription,
      location: location

    }
  end
end
