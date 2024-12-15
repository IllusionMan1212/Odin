#+build vita
package vita

import "core:c"

foreign import http "system:SceHttp_stub"

SCE_HTTP_DEFAULT_RESOLVER_TIMEOUT : c.uint : (1 * 1000 * 1000)
SCE_HTTP_DEFAULT_RESOLVER_RETRY : c.uint : (5)
SCE_HTTP_DEFAULT_CONNECT_TIMEOUT : c.uint : (30 * 1000 * 1000)
SCE_HTTP_DEFAULT_SEND_TIMEOUT : c.uint : (120 * 1000 * 1000)
SCE_HTTP_DEFAULT_RECV_TIMEOUT : c.uint : (120 * 1000 * 1000)
SCE_HTTP_DEFAULT_RECV_BLOCK_SIZE : c.uint : (1500)
SCE_HTTP_DEFAULT_RESPONSE_HEADER_MAX : c.uint : (5000)
SCE_HTTP_DEFAULT_REDIRECT_MAX : c.uint : (6)
SCE_HTTP_DEFAULT_TRY_AUTH_MAX : c.uint : (6)

SCE_HTTP_INVALID_ID :: 0

SceHttpErrorCode :: enum c.uint {
    BEFORE_INIT                 = 0x80431001,
    ALREADY_INITED              = 0x80431020,
    BUSY                        = 0x80431021,
    OUT_OF_MEMORY               = 0x80431022,
    NOT_FOUND                   = 0x80431025,
    INVALID_VERSION             = 0x8043106A,
    INVALID_ID                  = 0x80431100,
    OUT_OF_SIZE                 = 0x80431104,
    INVALID_VALUE               = 0x804311FE,
    INVALID_URL                 = 0x80433060,
    UNKNOWN_SCHEME              = 0x80431061,
    NETWORK                     = 0x80431063,
    BAD_RESPONSE                = 0x80431064,
    BEFORE_SEND                 = 0x80431065,
    AFTER_SEND                  = 0x80431066,
    TIMEOUT                     = 0x80431068,
    UNKOWN_AUTH_TYPE            = 0x80431069,
    UNKNOWN_METHOD              = 0x8043106B,
    READ_BY_HEAD_METHOD         = 0x8043106F,
    NOT_IN_COM                  = 0x80431070,
    NO_CONTENT_LENGTH           = 0x80431071,
    CHUNK_ENC                   = 0x80431072,
    TOO_LARGE_RESPONSE_HEADER   = 0x80431073,
    SSL                         = 0x80431075,
    ABORTED                     = 0x80431080,
    UNKNOWN                     = 0x80431081,
    PARSE_HTTP_NOT_FOUND        = 0x80432025,
    PARSE_HTTP_INVALID_RESPONSE = 0x80432060,
    PARSE_HTTP_INVALID_VALUE    = 0x804321FE,
    RESOLVER_EPACKET            = 0x80436001,
    RESOLVER_ENODNS             = 0x80436002,
    RESOLVER_ETIMEDOUT          = 0x80436003,
    RESOLVER_ENOSUPPORT         = 0x80436004,
    RESOLVER_EFORMAT            = 0x80436005,
    RESOLVER_ESERVERFAILURE     = 0x80436006,
    RESOLVER_ENOHOST            = 0x80436007,
    RESOLVER_ENOTIMPLEMENTED    = 0x80436008,
    RESOLVER_ESERVERREFUSED     = 0x80436009,
    RESOLVER_ENORECORD          = 0x8043600A,
}

SceHttpsErrorCode :: enum c.uint {
    CERT      = 0x80435060,
    HANDSHAKE = 0x80435061,
    IO        = 0x80435062,
    INTERNAL  = 0x80435063,
    PROXY     = 0x80435064,
}

SceHttpsSslErrorCode :: enum c.uint {
    INTERNAL         = (0x01),
    INVALID_CERT     = (0x02),
    CN_CHECK         = (0x04),
    NOT_AFTER_CHECK  = (0x08),
    NOT_BEFORE_CHECK = (0x10),
    UNKNOWN_CA       = (0x20),
}

SCE_HTTP_ENABLE :: (1)
SCE_HTTP_DISABLE :: (0)

SCE_HTTP_USERNAME_MAX_SIZE :: 256
SCE_HTTP_PASSWORD_MAX_SIZE :: 256

SceHttpStatusCode :: enum c.int {
    CONTINUE                      = 100,
    SWITCHING_PROTOCOLS           = 101,
    PROCESSING                    = 102,
    OK                            = 200,
    CREATED                       = 201,
    ACCEPTED                      = 202,
    NON_AUTHORITATIVE_INFORMATION = 203,
    NO_CONTENT                    = 204,
    RESET_CONTENT                 = 205,
    PARTIAL_CONTENT               = 206,
    MULTI_STATUS                  = 207,
    MULTIPLE_CHOICES              = 300,
    MOVED_PERMANENTLY             = 301,
    FOUND                         = 302,
    SEE_OTHER                     = 303,
    NOT_MODIFIED                  = 304,
    USE_PROXY                     = 305,
    TEMPORARY_REDIRECT            = 307,
    BAD_REQUEST                   = 400,
    UNAUTHORIZED                  = 401,
    PAYMENT_REQUIRED              = 402,
    FORBIDDDEN                    = 403,
    NOT_FOUND                     = 404,
    METHOD_NOT_ALLOWED            = 405,
    NOT_ACCEPTABLE                = 406,
    PROXY_AUTHENTICATION_REQUIRED = 407,
    REQUEST_TIME_OUT              = 408,
    CONFLICT                      = 409,
    GONE                          = 410,
    LENGTH_REQUIRED               = 411,
    PRECONDITION_FAILED           = 412,
    REQUEST_ENTITY_TOO_LARGE      = 413,
    REQUEST_URI_TOO_LARGE         = 414,
    UNSUPPORTED_MEDIA_TYPE        = 415,
    REQUEST_RANGE_NOT_SATISFIBLE  = 416,
    EXPECTATION_FAILED            = 417,
    UNPROCESSABLE_ENTITY          = 422,
    LOCKED                        = 423,
    FAILED_DEPENDENCY             = 424,
    UPGRADE_REQUIRED              = 426,
    INTERNAL_SERVER_ERROR         = 500,
    NOT_IMPLEMENTED               = 501,
    BAD_GATEWAY                   = 502,
    SERVICE_UNAVAILABLE           = 503,
    GATEWAY_TIME_OUT              = 504,
    HTTP_VERSION_NOT_SUPPORTED    = 505,
    INSUFFICIENT_STORAGE          = 507,
}

SceHttpUriBuildType :: enum c.int {
    WITH_SCHEME   = 0x01,
    WITH_HOSTNAME = 0x02,
    WITH_PORT     = 0x04,
    WITH_PATH     = 0x08,
    WITH_USERNAME = 0x10,
    WITH_PASSWORD = 0x20,
    WITH_QUERY    = 0x40,
    WITH_FRAGMENT = 0x80,
    WITH_ALL      = 0xFFFF,
}

SceHttpsFlag :: enum c.uint {
    SERVER_VERIFY    = (0x01),
    CLIENT_VERIFY    = (0x02),
    CN_CHECK         = (0x04),
    NOT_AFTER_CHECK  = (0x08),
    NOT_BEFORE_CHECK = (0x10),
    KNOWN_CA_CHECK   = (0x20),
}

SceHttpMemoryPoolStats :: struct {
    poolSize:         c.uint,
    maxInuseSize:     c.uint,
    currentInuseSize: c.uint,
    reserved:         c.int,
}
#assert(size_of(SceHttpMemoryPoolStats) == 0x10)

SceHttpMethods :: enum c.int {
    GET,
    POST,
    HEAD,
    OPTIONS,
    PUT,
    DELETE,
    TRACE,
    CONNECT,
}

SceHttpUriElement :: struct {
    opaque:   c.int, // 4
    scheme:   cstring,
    username: cstring,
    password: cstring,
    hostname: cstring,
    path:     cstring,
    query:    cstring,
    fragment: cstring,
    port:     c.ushort, // 2
    reserved: [10]c.uchar, // 10
}

SceHttpVersion :: enum c.int {
    VERSION_1_0 = 1,
    VERSION_1_1,
}

SceHttpProxyMode :: enum c.int {
    AUTO,
    MANUAL,
}

SceHttpAddHeaderMode :: enum c.int {
    OVERWRITE,
    ADD,
}

SceHttpAuthType :: enum c.int {
    BASIC,
    DIGEST,
    RESERVED0,
    RESERVED1,
    RESERVED2,
}

SceHttpSslVersion :: enum c.int {
    SSLV23,
    SSLV2,
    SSLV3,
    TLSV1,
}

SceHttpsData :: struct {
    ptr: ^c.char,
    size: c.uint,
}

SceHttpsCaList :: struct {
    caCerts: ^rawptr,
    caNum:   c.int,
}

/* callbacks */

SceHttpAuthInfoCallback :: #type ^proc(
    request: c.int,
    authType: SceHttpAuthType,
    realm: cstring,
    username: cstring,
    password: cstring,
    needEntity: c.int,
    entityBody: ^[^]c.uchar,
    entitySize: ^c.uint,
    save: ^c.int,
    userArg: rawptr,
) -> c.int

SceHttpRedirectCallback :: #type ^proc(
    request: c.int,
    statusCode: c.int,
    method: ^c.int,
    location: cstring,
    userArg: rawptr,
) -> c.int

SceHttpsCallback :: #type ^proc(verifyEsrr: c.uint, sslCert: []rawptr, certNum: c.int, userArg: rawptr) -> c.int

SceHttpCookieRecvCallback :: #type ^proc(
    request: c.int,
    url: cstring,
    cookieHeader: cstring,
    headerLen: c.uint,
    userArg: rawptr,
)

SceHttpCookieSendCallback :: #type ^proc(request: c.int, url: cstring, cookieHeader: cstring, userArg: rawptr)

foreign http {
    HttpInit :: proc(poolSize: c.uint) -> c.int ---
    HttpTerm :: proc() -> c.int ---
    HttpGetMemoryPoolStats :: proc(currentStat: ^SceHttpMemoryPoolStats) -> c.int ---

    HttpSetAuthInfoCallback :: proc(id: c.int, cbfunc: SceHttpAuthInfoCallback, userArg: rawptr) -> c.int ---
    HttpSetAuthEnabled :: proc(id: c.int, enable: c.int) -> c.int ---
    HttpGetAuthEnabled :: proc(id: c.int, enable: ^c.int) -> c.int ---
    HttpSetRedirectCallback :: proc(id: c.int, cbfunc: SceHttpRedirectCallback, userArg: rawptr) -> c.int ---
    HttpSetAutoRedirect :: proc(id: c.int, enable: c.int) -> c.int ---
    HttpGetAutoRedirect :: proc(id: c.int, enable: ^c.int) -> c.int ---
    HttpSetResolveTimeOut :: proc(id: c.int, usec: c.uint) -> c.int ---
    HttpSetResolveRetry :: proc(id: c.int, retry: c.int) -> c.int ---
    HttpSetConnectTimeOut :: proc(id: c.int, usec: c.uint) -> c.int ---
    HttpSetSendTimeOut :: proc(id: c.int, usec: c.uint) -> c.int ---
    HttpSetRecvTimeOut :: proc(id: c.int, usec: c.uint) -> c.int ---

    HttpSendRequest :: proc(reqId: c.int, postData: rawptr, size: c.uint) -> c.int ---
    HttpAbortRequest :: proc(reqId: c.int) -> c.int ---
    HttpGetResponseContentLength :: proc(reqId: c.int, contentLength: ^c.ulonglong) -> c.int ---
    HttpGetStatusCode :: proc(reqId: c.int, statusCode: ^c.int) -> c.int ---
    HttpGetAllResponseHeaders :: proc(reqId: c.int, header: ^[^]c.char, headerSize: ^c.uint) -> c.int ---
    HttpReadData :: proc(reqId: c.int, data: rawptr, size: c.uint) -> c.int ---
    HttpAddRequestHeader :: proc(id: c.int, name: cstring, value: cstring, mode: c.uint) -> c.int ---
    HttpRemoveRequestHeader :: proc(id: c.int, name: cstring) -> c.int ---

    HttpParseResponseHeader :: proc(header: cstring, headerLen: c.uint, fieldStr: cstring, fieldValue: ^cstring, valueLen: ^c.uint) -> c.int ---
    HttpParseStatusLine :: proc(statusLine: cstring, lineLen: c.uint, httpMajorVer: ^c.int, httpMinorVer: ^c.int, responseCode: ^c.int, reasonPhrase: ^cstring, phraseLen: ^c.uint) -> c.int ---

    HttpCreateTemplate :: proc(userAgent: cstring, httpVer: SceHttpVersion, autoProxyConf: SceHttpProxyMode) -> c.int ---
    HttpDeleteTemplate :: proc(tmplId: c.int) -> c.int ---
    HttpCreateConnection :: proc(tmplId: c.int, serverName: cstring, scheme: cstring, port: c.ushort, enableKeepalive: c.int) -> c.int ---
    HttpCreateConnectionWithURL :: proc(tmplId: c.int, url: cstring, enableKeepalive: c.int) -> c.int ---
    HttpDeleteConnection :: proc(connId: c.int) -> c.int ---
    HttpCreateRequest :: proc(connId: c.int, method: c.int, path: cstring, contentLength: c.ulonglong) -> c.int ---
    HttpCreateRequestWithURL :: proc(connId: c.int, method: c.int, url: cstring, contentLength: c.ulonglong) -> c.int ---
    HttpDeleteRequest :: proc(reqId: c.int) -> c.int ---
    HttpSetResponseHeaderMaxSize :: proc(id: c.int, headerSize: c.uint) -> c.int ---
    HttpSetRequestContentLength :: proc(id: c.int, contentLength: c.ulonglong) -> c.int ---

    // uri
    HttpUriEscape :: proc(out: cstring, require: ^c.uint, prepare: c.uint, _in: cstring) -> c.int ---
    HttpUriUnescape :: proc(out: cstring, require: ^c.uint, prepare: c.uint, _in: cstring) -> c.int ---
    HttpUriParse :: proc(out: ^SceHttpUriElement, srcUrl: cstring, pool: rawptr, require: ^c.uint, prepare: c.uint) -> c.int ---
    HttpUriBuild :: proc(out: cstring, require: ^c.uint, prepare: c.uint, srcElement: ^SceHttpUriElement, option: c.uint) -> c.int ---
    HttpUriMerge :: proc(mergedUrl: cstring, url: cstring, relativeUrl: cstring, require: ^c.uint, prepare: c.uint, option: c.uint) -> c.int ---
    HttpUriSweepPath :: proc(dst: cstring, src: cstring, srcSize: c.uint) -> c.int ---

    // https
    /**
	* Register RootCA certificate for HTTPS authentication
	*
	* @param[in] caCertNum - Number of elements of the list referncing to RootCA certificate
	* @param[in] caList - List referencing to RootCA certificate
	* @param[in] cert - Client certificate
	* @param[in] privKey - Private key
	*
	* @return 0 on success, < 0 on error.
	*
	* @note <b>SCE_SYSMODULE_HTTPS</b> module must be loaded with ::sceSysmoduleLoadModule to use this function.
	*/
    HttpsLoadCert :: proc(caCertNum: c.int, caList: [^]SceHttpsData, cert: ^SceHttpsData, privKey: ^SceHttpsData) -> c.int ---
    HttpsUnloadCert :: proc() -> c.int ---
    HttpsEnableOption :: proc(sslFlags: c.uint) -> c.int ---
    HttpsDisableOption :: proc(sslFlags: c.uint) -> c.int ---
    HttpsGetSslError :: proc(id: c.int, errNum: ^c.int, detail: ^c.uint) -> c.int ---
    HttpsSetSslCallback :: proc(id: c.int, cbfunc: SceHttpsCallback, userArg: rawptr) -> c.int ---
    HttpsGetCaList :: proc(caList: ^SceHttpsCaList) -> c.int ---
    HttpsFreeCaList :: proc(caList: ^SceHttpsCaList) -> c.int ---

    // cookie
    HttpSetCookieEnabled :: proc(id: c.int, enable: c.int) -> c.int ---
    HttpGetCookieEnabled :: proc(id: c.int, enable: ^c.int) -> c.int ---
    HttpGetCookie :: proc(url: cstring, cookie: cstring, cookieLength: ^c.uint, prepare: c.uint, secure: c.int) -> c.int ---
    HttpAddCookie :: proc(url: cstring, cookie: cstring, cookieLength: c.uint) -> c.int ---
    HttpSetCookieRecvCallback :: proc(id: c.int, cbfunc: SceHttpCookieRecvCallback, userArg: rawptr) -> c.int ---
    HttpSetCookieSendCallback :: proc(id: c.int, cbfunc: SceHttpCookieSendCallback, userArg: rawptr) -> c.int ---
}

