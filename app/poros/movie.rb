# frozen_string_literal: true

class Movie
  attr_reader :id,
              :original_title,
              :runtime,
              :vote_count,
              :vote_average,
              :overview,
              :image,
              :genres

  def initialize(data)
    @id = data[:id]
    @original_title = data[:original_title]
    @runtime = data[:runtime]
    @vote_count = data[:vote_count]
    @vote_average = data[:vote_average]
    @overview = data[:overview]
    @image = "https://image.tmdb.org/t/p/w185/#{data[:poster_path]}"
    @genres = data[:genres]
  end

  def standard_runtime
    hrs = @runtime / 60
    mins = @runtime % 60
    "#{hrs}hr #{mins} min"
  end

  def genre_names
    final = []
    @genres.each do |gen|
      final << gen[:name]
    end

    final
  end
end
