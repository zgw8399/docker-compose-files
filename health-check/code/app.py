import tornado.ioloop
import tornado.web

# Windows系统下tornado的使用，使用SelectorEventLoop
import platform
if platform.system() == "Windows":
    import asyncio
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")


class HealthcheckHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Service is healthy")


def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
        (r"/healthz", HealthcheckHandler),
    ])


if __name__ == "__main__":
    app = make_app()
    app.listen(80)
    tornado.ioloop.IOLoop.current().start()
