defmodule BlockScoutWeb.LocaleController do

  use BlockScoutWeb, :controller

  def setLocale(conn, _query) do
    json conn, %{"hello": "TideBit"}
    # conn
  end

  # def setLocale(conn, _query) do
  #   Gettext.put_locale(DemoWeb.Gettext, locale)
  #   conn # <===
  # end
end
