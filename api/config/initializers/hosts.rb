Rails.application.config.hosts = [
    IPAddr.new("0.0.0.0/0"),
    IPAddr.new("::/0"),
    "localhost",
    ENV['HOSTS']
]
