class Fixnum
  def days; self; end
end

# The way to get to a real controller behind the middleware.
def real_controller; Controller.actual_object; end
