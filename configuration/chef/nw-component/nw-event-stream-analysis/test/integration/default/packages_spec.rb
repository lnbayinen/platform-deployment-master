# encoding: utf-8
# author: Adam Snodgrass

title 'Operating System Packages'

pkgs = %w(
  rsa-esa-server
  rsa-nw-esa-analytics-server
  rsa-esa-client
  rsa-context-hub-server
)
pkgs.each do |pkg|
  control "os-package-#{pkg}" do
    impact 1.0
    title "NW-ESA: Install the #{pkg} package"
    desc "Ensures that the required #{pkg} package is installed"
    tag 'rpm', 'package'

    describe package(pkg) do
      it { should be_installed }
    end
  end
end
