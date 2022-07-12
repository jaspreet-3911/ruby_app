class LogExtractor
  class FileError < StandardError; end

  def self.run(args)
    new(args).perform
  end

  def initialize(filename)
    @filename = filename
    @unique_data = {}
    @data = {}
  end

  def perform
    validate; extract; print
  end

  private

  def validate
    raise FileError.new "File does not exist in the path { #{@filename} }" unless File.exists? @filename
    raise FileError.new "File is empty!" if File.empty? @filename
  end

  def extract
    # used to store unique IP for paths
    temp_ip = {}
    # foreach used to avoid memory issues for large file
    # will load line by line in memory
    IO.foreach(@filename, chomp: true) do |line|
      path, ip = line.split(' ')
      temp_ip[path] ||= []; temp_ip[path] << ip
      @unique_data[path] = temp_ip[path].uniq.count
      @data[path] = @data[path].to_i + 1
    end
  end

  def print
    puts "**** List of webpages with most page views ordered from most pages views to less page views ****"
    @data.sort_by(&:last).reverse.each { |line| puts "#{line[0]} #{line[1]} visits"}

    puts "**** List of webpages with most unique page views also ordered ****"
    @unique_data.sort_by(&:last).reverse.each { |line| puts "#{line[0]} #{line[1]} unique views"}
  end
end