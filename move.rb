require 'FileUtils'
require 'json'

START=[31.9122178,131.4075771] # [latitude,longitude]
DATA_DIR = "./data"

class Pos
  def initialize(id, start = nil)
    @id = id
    @start = start || START
    @file = File.open("#{DATA_DIR}/#{id}.json","w")
  end

  def move
    @x ||=  @start[0]
    @y ||=  @start[1]
    @x += (rand(-1..1) * 0.001)
    @y += (rand(-1..1) * 0.001)
    @file.rewind 
    json = JSON.dump(@id => {latitude: @x, longitude: @y})
    puts json
    @file.write(json)
    @file.flush
    @file.truncate(@file.pos)
  end
end

FileUtils.mkdir_p(DATA_DIR)
pos_a = Pos.new("a")

while(true) do
  pos_a.move
  sleep(1)
end
