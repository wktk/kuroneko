# -*- encoding: utf-8 -*-

require 'mechanize'
require 'kuroneko/parser'
require 'kuroneko/version'

# クロネコヤマトの荷物を追跡する
#
# @see http://toi.kuronekoyamato.co.jp/cgi-bin/tneko
class Kuroneko
  # @return [String] 問い合わせフォームの URL
  URL = 'http://toi.kuronekoyamato.co.jp/cgi-bin/tneko'.freeze

  class << self
    %i[
      history
      histories
      status
      statuses
    ].each do |name|
      define_method(name) { |*args| instance.__send__(name, *args) }
    end

    private

    def instance
      @instance ||= new
    end
  end

  # @return [Mechanize] 使用する Mechanize インスタンス
  attr_accessor :agent

  # @return [#parse] ページを解析するパーサ
  attr_accessor :parser

  # @return [String] 問い合わせフォームの URL
  attr_accessor :url

  # インスタンスを初期化する
  #
  # @param [Hash] options
  # @option options [Mechanize] :agent 使用する Mechanize インスタンス
  # @option options [#parse] :parser ページを解析するパーサ
  # @option options [String] :url 問い合わせフォームの URL
  def initialize(options={})
    @agent = options[:agent] || Mechanize.new
    @parser = options[:parser] || Parser
    @url = options[:url] || URL.dup
  end

  # 1 つの荷物の状態履歴を照会する
  #
  # @param [String, #to_s] number 伝票番号
  # @return [Kuroneko::History<Kuroneko::Status>] 状態履歴
  def history(number)
    histories(number).first
  end

  # 複数の荷物の状態履歴を照会する
  #
  # @param [Array<String, #to_s>] numbers 伝票番号
  # @return [Array<Kuroneko::History<Kuroneko::Status>>] 状態履歴
  def histories(*numbers)
    numbers.flatten.each_slice(10).map { |n| query(n) }.flatten(1)
  end

  # 1 つの荷物の最新状態を照会する
  #
  # @param [String, #to_s] number 伝票番号
  # @return [Kuroneko::Status] 最新状態
  def status(number)
    history(number).latest
  end

  # 複数の荷物の最新状態を取得する
  #
  # @param [Array<String, #to_s>] numbers 伝票番号
  # @return [Array<Kuroneko::Status>] 最新状態
  def statuses(*numbers)
    histories(*numbers).map(&:latest)
  end

private

  # フォームパラメータをセットする
  #
  # @param [Mechanize::Form] form
  # @param [Array<String, #to_s>] numbers 伝票番号
  # @return [void]
  def prepare_form(form, numbers)
    numbers.each.with_index(1) do |number, index|
      form["number%02d" % index] = number
    end
  end

  # リクエストを送信して状態を抽出する
  #
  # @param [Array<String, #to_s>] numbers 伝票番号
  # @return [Array<Kuroneko::History<Kuroneko::Status>>] 状態履歴
  def query(numbers)
    result_page = request(numbers)
    parser.parse(result_page)
  end

  # 照会リクエストを送る
  #
  # @param [Array<String, #to_s>] numbers 伝票番号、1 度に 10 件まで
  # @return [Mechanize::Page] 照会結果のページ
  def request(numbers)
    form = agent.get(url).form
    prepare_form(form, numbers)
    form.submit
  end

end
