class Array
  def eval_find
    self.each do |e|
      res = yield(e)
      return res if res 
    end
    nil 
  end
end