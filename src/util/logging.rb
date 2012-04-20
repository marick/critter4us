class Logger
  def tmi(*args); verbose(*args); end
  def cya(*args); debug(*args); end
  def fyi(*args); info(*args); end
  def wtf(*args); warn(*args); end
  def omg(*args); error(*args); end
  def fml(*args); fatal(*args); end
end
