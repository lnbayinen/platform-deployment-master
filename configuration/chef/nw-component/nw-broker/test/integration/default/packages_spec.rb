# encoding: utf-8
# author: Adam Snodgrass

title 'Operating System Packages'

pkgs = %w(
  nwappliance
  nwbroker
  nwconsole
)
pkgs.each do |pkg|
  control "os-package-#{pkg}" do
    impact 1.0
    title "NW-Broker: Install the #{pkg} package"
    desc "Ensures that the required #{pkg} package is installed"
    tag 'rpm', 'package'

    describe package(pkg) do
      it { should be_installed }
    end
  end
end
