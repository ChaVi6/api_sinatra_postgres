class Apply < Sequel::Model
  plugin :validation_helpers

  many_to_one :job
  many_to_one :geek

  def validate
    super
    validates_presence [:job_id, :geek_id]
    validates_unique [:job_id, :geek_id], message: "Geek already applied to this job"
  end

  def self.read
    where(read: true)
  end

  def self.unread
    where(read: false)
  end

  def to_api
    {
      id: id,
      job_id: job_id,
      geek_id: geek_id,
      read: read,
      invited: invited
    }
  end
end