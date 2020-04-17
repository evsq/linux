%define version 1.16.0

%global service_name crio

Name:           cri-o
Version:        %{version}
Release:        0
Summary:        Kubernetes Container Runtime Interface for OCI-based containers

License:        ASL 2.0
URL:            https://github.com/cri-o/cri-o
Source0:        crio-%{version}.tar.gz


%description
Kubernetes Container Runtime Interface for OCI-based containers

%prep
tar xvzf %{SOURCE0}

#%build

%install
install -dp %{buildroot}{%{_bindir},%{_libexecdir}/%{service_name}}
# install crio binaries
install -p -m 755 crio-%{version}/bin/%{service_name} %{buildroot}%{_bindir}
install -p -m 755 crio-%{version}/bin/%{service_name}-status %{buildroot}%{_bindir}
install -p -m 755 crio-%{version}/bin/conmon %{buildroot}%{_bindir}
install -p -m 755 crio-%{version}/bin/pause %{buildroot}%{_libexecdir}/%{service_name}
# install conf files
install -dp %{buildroot}%{_sysconfdir}/cni/net.d
install -dp %{buildroot}%{_sysconfdir}/%{service_name}
install -dp %{buildroot}%{_datadir}/containers/oci/hooks.d
install -dp %{buildroot}%{_datadir}/oci-umount/oci-umount.d
install -p -m 644 crio-%{version}/crio.conf %{buildroot}%{_sysconfdir}/%{service_name}
install -p -m 644 crio-%{version}/crio-umount.conf %{buildroot}%{_datadir}/oci-umount/oci-umount.d/%{service_name}-umount.conf
install -p -m 644 crio-%{version}/crictl.yaml %{buildroot}%{_sysconfdir}
# install sysconfig
install -dp %{buildroot}%{_sysconfdir}/sysconfig
install -p -m 644 crio-%{version}/sysconfig/%{service_name} %{buildroot}%{_sysconfdir}/sysconfig/%{service_name}
# install services
install -dp %{buildroot}%{_unitdir}
install -p -m 644 -t %{buildroot}%{_unitdir} crio-%{version}/services/%{service_name}.service crio-%{version}/services/%{service_name}-wipe.service crio-%{version}/services/%{service_name}-shutdown.service
# install docs
install -dp %{buildroot}{%{_mandir}/man5,%{_mandir}/man8}
install -p -m 644 crio-%{version}/docs/crio.conf.5 %{buildroot}%{_mandir}/man5/%{service_name}.conf.5
install -p -m 644 -t %{buildroot}%{_mandir}/man8 crio-%{version}/docs/crio-status.8 crio-%{version}/docs/crio.8


%files
%dir %{_libexecdir}/%{service_name}
%{_bindir}/%{service_name}
%{_bindir}/%{service_name}-status
%{_bindir}/conmon
%{_libexecdir}/%{service_name}/pause
%dir %{_sysconfdir}/cni/net.d
%dir %{_sysconfdir}/%{service_name}
%dir %{_datadir}/oci-umount
%dir %{_datadir}/oci-umount/oci-umount.d
%{_sysconfdir}/sysconfig/%{service_name}
%{_sysconfdir}/%{service_name}/%{service_name}.conf
%{_datadir}/oci-umount/oci-umount.d/%{service_name}-umount.conf
%{_sysconfdir}/crictl.yaml
%{_unitdir}/%{service_name}.service
%{_unitdir}/%{service_name}-shutdown.service
%{_unitdir}/%{service_name}-wipe.service
%{_mandir}/man5/%{service_name}.conf.5*
%{_mandir}/man8/%{service_name}.8*
%{_mandir}/man8/%{service_name}-status.8*
