class Company < Sequel::Model
  plugin :validation_helpers

  one_to_many :jobs

  dataset_module do
    def by_name(name)
      where(name: /#{name}/i) if name
    end

    def by_location(location)
      where(location: /#{location}/i) if location
    end

    def active
      where(deleted: false)
    end
  end

  def validate
    super
    validates_presence [:name, :location]
    validates_min_length 3, :name, message: "must be at least 3 characters"
    validates_min_length 3, :location, message: "must be at least 3 characters"
  end

  def delete_company
    update(deleted: true)
  end

  def to_api
    {
      id: id,
      name: name,
      location: location,
      deleted: deleted
    }
  end
end