# Serializes
class Api::V1::Preview::ResultsSerializer
  def initialize(search_results)
    @results = {}
    search_results.each do |result|
      if result.klass.to_s == "Book"
        @results[:books] = ActiveModel::ArraySerializer.new(result.results,
          each_serializer: Api::V1::Preview::BookSerializer)
      elsif result.klass.to_s == "Author"
        @results[:authors] = ActiveModel::ArraySerializer.new(result.results,
          each_serializer: Api::V1::Preview::AuthorSerializer)
      elsif result.klass.to_s == "Publisher"
        @results[:publishers] = ActiveModel::ArraySerializer.new(result.results,
          each_serializer: Api::V1::Preview::PublisherSerializer)
      elsif result.klass.to_s == "Category"
        @results[:categories] = ActiveModel::ArraySerializer.new(result.results,
          each_serializer: Api::V1::Preview::CategorySerializer)
      end
    end
  end
end
