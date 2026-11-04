class Job < Sequel::Model
  plugin :validation_helpers

  many_to_one :company
  one_to_many :applies

  PLACES = ['Remote', 'Contract', 'Permanent', 'Office', 'Hybrid'].freeze

  dataset_module do
    def place(p)
      where(place: p) if p
    end

    def name(n)
      where(name: /#{n}/i) if n
    end
  end

  def validate
    super
    validates_presence [:name, :place, :company_id]
    validates_includes PLACES, :place, allow_nil: true, message: "is not a valid place"
  end

  def to_api
    { id: id, name: name, place: place, company_id: company_id }
  end
end