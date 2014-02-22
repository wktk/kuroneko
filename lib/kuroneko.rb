# -*- encoding: utf-8 -*-

require 'mechanize'
require 'kuroneko/status'
require 'kuroneko/status_history'
require 'kuroneko/version'

# クロネコヤマトの荷物を追跡する
#
# @see http://toi.kuronekoyamato.co.jp/cgi-bin/tneko
class Kuroneko
  # @return [String] 問い合わせフォームの URL
  URL = 'http://toi.kuronekoyamato.co.jp/cgi-bin/tneko'.freeze

  # @return [Mechanize] 使用する Mechanize インスタンス
  attr_accessor :agent

  # @return [String] 問い合わせフォームの URL
  attr_accessor :url

  # インスタンスを初期化する
  #
  # @param [Hash] options
  # @option options [Mechanize] :agent 使用する Mechanize インスタンス
  # @option options [String] :url 問い合わせフォームの URL
  def initialize(options={})
    @agent = options[:agent] || Mechanize.new
    @url = options[:url] || URL.dup
  end

  # 1 つの荷物の状態履歴を照会する
  #
  # @param [String, #to_s] number 伝票番号
  # @return [Kuroneko::StatusHistory<Kuroneko::Status>] 状態履歴
  def history(number)
    histories(number).first
  end

  # 複数の荷物の状態履歴を照会する
  #
  # @param [Array<String, #to_s>] numbers 伝票番号
  # @return [Array<Kuroneko::StatusHistory<Kuroneko::Status>>] 状態履歴
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

  # 履歴情報を解析する
  #
  # @param [Nokogiri::XML::Element] summary <table class="saisin">
  # @return [Kuroneko::StatusHistory<Kuroneko::Status>] 状態履歴
  def parse_history(summary)
    number, status = parse_meta(summary)
    statuses = summary.parent.css('table.meisai').first
    statuses = statuses ? parse_statuses(statuses) : [[true, status]]
    StatusHistory.new(number, statuses.map { |s| Status.new(number, *s) })
  end

  # 伝票番号と最新状態名を抽出する
  #
  # @param [Nokogiri::XML::Element] summary <table class="saisin">
  # @return [Array] 伝票番号, 最新状態名
  def parse_meta(summary)
    rows = summary.css('tr')
    number = rows[0].css('td')[2].text.gsub(/\D/, '')
    status = rows[1].css('td')[2].text
    [number, status]
  end

  # ページをから情報を抽出する
  #
  # @param [Mechanize::Page] page 照会結果のページ
  # @return [Array<Kuroneko::StatusHistory<Kuroneko::Status>>] 状態履歴
  def parse_page(page)
    page.parser.css('table.saisin').map(&method(:parse_history))
  end

  # 状態を解析する
  #
  # @param [Nokogiri::XML::Element] status 状態情報のテーブル行
  # @return [Array] Kuroneko::Status への引数
  def parse_status(status)
    attrs = status.css('td').to_a
    latest = attrs.shift.css('img').attribute('alt').value == '最新'
    [latest] + attrs.map(&:text)
  end

  # 状態履歴テーブルを解析する
  #
  # @param [Nokogiri::XML::Element] table <table class="meisai">
  # @return [Array<Array>] Kuroneko::Status への引数
  def parse_statuses(table)
    statuses = table.css('tr').to_a
    statuses.shift
    statuses.map(&method(:parse_status))
  end

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
  # @return [Array<Kuroneko::StatusHistory<Kuroneko::Status>>] 状態履歴
  def query(numbers)
    result_page = request(numbers)
    parse_page(result_page)
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
