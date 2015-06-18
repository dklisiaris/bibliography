class Api::V1::Preview::AuthorSerializer < Api::V1::BaseSerializer
  attributes :id, :firstname, :lastname, :url

  def attributes
    data = super
    data[:job] = job unless job.nil?
    data
  end  

  def job
    return object.job if object.job.present?
    nil
  end

end