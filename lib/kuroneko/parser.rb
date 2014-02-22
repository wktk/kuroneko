# -*- coding: utf-8 -*-
require 'kuroneko/history'
require 'kuroneko/status'

class Kuroneko
  # ページからデータを抽出する
  module Parser
    class << self
      # ページをから情報を抽出する
      #
      # @param [Mechanize::Page] page 照会結果のページ
      # @return [Array<Kuroneko::History<Kuroneko::Status>>] 状態履歴
      def parse_page(page)
        page.parser.css('table.saisin').map(&method(:parse_history))
      end

      alias parse parse_page

      private

      # 履歴情報を解析する
      #
      # @param [Nokogiri::XML::Element] summary <table class="saisin">
      # @return [Kuroneko::History<Kuroneko::Status>] 状態履歴
      def parse_history(summary)
        number, status = parse_meta(summary)
        statuses = summary.parent.css('table.meisai').first
        statuses = statuses ? parse_statuses(statuses) : [[true, status]]
        History.new(number, statuses.map { |s| Status.new(number, *s) })
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

    end
  end
end
