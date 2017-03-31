Name: nwnodeX-bootstrap
Version: 0
Release: 1
Summary: Script that bootstraps NetWitness Node X
Source0: nwnodeX-bootstrap-0.1.tar.gz
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
install -m 0755 -d $RPM_BUILD_ROOT/opt/rsa/nwnodeX-boostrap
install -m 0755 bootstrap-nodeX.sh $RPM_BUILD_ROOT/opt/rsa/nwnodeX-boostrap/bootstrap-nodeX.sh
%clean
rm -rf /opt/rsa/nwnodeX-boostrap
%post
%files
%dir /opt/rsa/nwnodeX-boostrap
/opt/rsa/nwnodeX-boostrap/bootstrap-nodeX.sh
