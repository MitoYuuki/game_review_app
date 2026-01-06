class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @keyword = params[:keyword]
    @model = params[:model]
    search_method = params[:method]

   @results =
      case @model
     when "user"
        User.where(
          build_query("name", search_method),
          build_keyword(search_method)
        )

      when "post"
        Post.where(
          build_query("title", search_method),
          build_keyword(search_method)
        )

     when "community"
        Community.where(
          build_query("name", search_method),
          build_keyword(search_method)
        )

      else
        []
      end
  end

  private
    def build_query(column, method)
      case method
      when "perfect"
        "#{column} = ?"
      when "forward"
        "#{column} LIKE ?"
      when "backward"
        "#{column} LIKE ?"
      else
        "#{column} LIKE ?"
      end
    end

    def build_keyword(method)
      case method
      when "perfect"
        params[:keyword]
      when "forward"
        "#{params[:keyword]}%"
      when "backward"
        "%#{params[:keyword]}"
      else
        "%#{params[:keyword]}%"
      end
    end
end
