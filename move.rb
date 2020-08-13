require 'json'

START = {latitude: 31.9122178, longitude: 131.4075771} # スタート地点
DATA_DIR = "./public/data"

class Pos
  def initialize(id, start = nil)
    @id = id
    file_path = "#{DATA_DIR}/#{id}.json"
    if File.exist?(file_path) && start == nil
      # ファイルが有る場合はファイルに書かれた位置をスタート地点にする
      @file = File.open(file_path, "r+")
      json = @file.read
      json.chomp!
      unless json.empty?
        data = JSON.parse(json, symbolize_names: true)
        start ||= data[id.to_sym]
      end
    else
      @file = File.open(file_path, "w")
    end
    @start = start || START
  end

  def move
    @x ||=  @start[:latitude]
    @y ||=  @start[:longitude]
    @x += (rand(-1..1) * 0.001)
    @y += (rand(-1..1) * 0.001)
    @file.rewind 
    json = JSON.dump(@id => {latitude: @x, longitude: @y})
    puts json
    @file.write(json) # このときファイルが削除されていても書き込みエラーにはならないが、ファイルが復活することもない
    @file.flush
    @file.truncate(@file.pos)
  end
end

FileUtils.mkdir_p(DATA_DIR)
positions = (0..246).to_a.map do |id| #ファイル開きっぱなしは247個が限界
  Pos.new(id.to_s)
end
while(true) do
  positions.each do |p|
    p.move
  end
  sleep(1)
end
