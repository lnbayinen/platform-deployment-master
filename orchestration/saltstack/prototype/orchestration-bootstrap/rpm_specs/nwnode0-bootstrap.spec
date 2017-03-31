Name: nwnode0-bootstrap
Version: 0
Release: 1
Summary: Script that bootstraps NetWitness Node 0
Source0: nwnode0-bootstrap-0.1.tar.gz
License: proprietary
Group: RSA
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-buildroot
%description
Yet another hello world RPM
%prep
%setup -q
%build
%install
install -m 0755 -d $RPM_BUILD_ROOT/opt/rsa/nwnode0-boostrap
install -m 0755 bootstrap-node0.sh $RPM_BUILD_ROOT/opt/rsa/nwnode0-boostrap/bootstrap-node0.sh
%clean
rm -rf /opt/rsa/nwnode0-boostrap
%post
%files
%dir /opt/rsa/nwnode0-boostrap
/opt/rsa/nwnode0-boostrap/bootstrap-node0.sh
