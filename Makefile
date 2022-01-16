package: package-rpm package-deb

ensure-build:
	mkdir -p build

package-rpm: ensure-build
	rm -f build/fck-nat-1.0.0-any.rpm
	fpm -t rpm -p build/fck-nat-1.0.0-any.rpm

package-deb: ensure-build
	rm -f build/fck-nat-1.0.0-any.deb
	fpm -t deb -p build/fck-nat-1.0.0-any.deb

al2-ami-arm64: package-rpm
	packer build -var-file="packer/fck-nat-arm64.pkrvars.hcl" -var-file="packer/fck-nat-al2.pkrvars.hcl" $(regions_file) packer/fck-nat.pkr.hcl

al2-ami-x86: package-rpm
	packer build -var-file="packer/fck-nat-x86_64.pkrvars.hcl" -var-file="packer/fck-nat-al2.pkrvars.hcl" $(regions_file) packer/fck-nat.pkr.hcl

al2-ami: al2-ami-arm64 al2-ami-x86

ubnt-ami-arm64: package-deb
	packer build -var-file="packer/fck-nat-arm64.pkrvars.hcl" -var-file="packer/fck-nat-ubnt.pkrvars.hcl" $(regions_file) packer/fck-nat.pkr.hcl

ubnt-ami-x86: package-deb
	packer build -var-file="packer/fck-nat-x86.pkrvars.hcl" -var-file="packer/fck-nat-ubnt.pkrvars.hcl" $(regions_file) packer/fck-nat.pkr.hcl

ubnt-ami: ubnt-ami-arm64 ubnt-ami-x86

all-amis: al2-ami ubnt-ami

publish: regions_file = "-var-file=\"packer/fck-nat-public-all-regions.pkrvars.hcl\""
publish: all-amis