PORTNAME=	lldap
DISTVERSIONPREFIX=	v
DISTVERSION=	0.6.1
CATEGORIES=	net

MAINTAINER=	ports@FreeBSD.org
COMMENT=	Light LDAP implementation
WWW=		https://github.com/lldap/lldap

LICENSE=	GPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	wasm-opt:devel/binaryen \
		wasm-bindgen:www/wasm-bindgen-cli \
		wasm-pack:www/wasm-pack
LIB_DEPENDS=	libzstd.so:archivers/zstd

USES=		cargo
USE_GITHUB=	yes

USE_RC_SUBR=	lldap

CARGO_BUILD_ARGS=	--workspace

INSTALLDIR=	${STAGEDIR}${LOCALBASE}/lib/${PORTNAME}

post-build:
	cd ${WRKSRC} && WASM_PACK_CACHE=.wasm-pack-cache ./app/build.sh

do-install:
	${MKDIR} ${INSTALLDIR}
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/lldap ${INSTALLDIR}
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/lldap_migration_tool ${INSTALLDIR}
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/lldap_set_password ${INSTALLDIR}
	${MKDIR} ${STAGEDIR}${ETCDIR}
	${INSTALL_DATA} ${WRKSRC}/lldap_config.docker_template.toml ${STAGEDIR}${ETCDIR}/lldap_config.toml.sample

	cd ${WRKSRC}/app && \
		${COPYTREE_SHARE} pkg ${INSTALLDIR}/app && \
		${COPYTREE_SHARE} static ${INSTALLDIR}/app && \
		${CP} index.html ${INSTALLDIR}/app
	${RLN} ${INSTALLDIR}/lldap ${STAGEDIR}${PREFIX}/bin/lldap
	${RLN} ${INSTALLDIR}/lldap_migration_tool ${STAGEDIR}${PREFIX}/bin/lldap_migration_tool
	${RLN} ${INSTALLDIR}/lldap_set_password ${STAGEDIR}${PREFIX}/bin/lldap_set_password

	${RM} ${LOCALBASE}/bin/wasm-pack.stamp
	${RM} ${INSTALLDIR}/app/pkg/.gitignore

.include <bsd.port.mk>
