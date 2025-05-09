PORTNAME=	lldap
DISTVERSIONPREFIX=	v
DISTVERSION=	0.6.1
CATEGORIES=	net

MAINTAINER=	ports@FreeBSD.org
COMMENT=	Light LDAP implementation
WWW=		https://github.com/lldap/lldap

LICENSE=	GPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	wasm-pack:www/wasm-pack

USES=		cargo
USE_GITHUB=	yes

USE_RC_SUBR=	lldap

CARGO_BUILD_ARGS=	--workspace

post-build:
	cd ${WRKSRC} && WASM_PACK_CACHE=.wasm-pack-cache ./app/build.sh

do-install:
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/lldap ${STAGEDIR}${LOCALBASE}/bin
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/lldap_migration_tool ${STAGEDIR}${LOCALBASE}/bin
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/lldap_set_password ${STAGEDIR}${LOCALBASE}/bin
	${MKDIR} ${STAGEDIR}${ETCDIR}
	${INSTALL_DATA} ${WRKSRC}/lldap_config.docker_template.toml ${STAGEDIR}${ETCDIR}/lldap_config.toml.sample

.include <bsd.port.mk>
