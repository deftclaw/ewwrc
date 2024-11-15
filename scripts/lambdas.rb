
require 'active_support/core_ext/hash/keys'
require 'json'

LD = {
  actives:  -> (clients) { clients.map{|r| r[:workspace]['id']}.uniq.sort                    },
  clients:  -> { JSON.parse(`hyprctl clients -j`).map(&:symbolize_keys)                      },
  desc:     -> (row) { row.split(/:\s/)[1..-1].join(' ')                                     },
  focus:    -> { LD[:clients].().select{|r| r[:focusHistoryID] == 0}.first[:workspace]['id'] },
  mon_name: -> (row) { row.gsub(/\:/, '').split(/\s/)[-1]                                    },
  sid:      -> (row) { LD[:second].call(row).to_i                                            },
  second:   -> (row) { row.split(/\s/)[1]                                                    },
  window_a: -> { JSON.parse(`hyprctl activewindow -j`)                                       },
  status:   -> (wsid){ 
    wsid.to_i == LD[:window_a].()['workspace']['id'] && (return :active)
    LD[:clients].().map{|c| c[:workspace]['id']}.uniq.include?(wsid.to_i) && (return :open)
    return :none
  },
  wsid:     -> (row) { row.split(/\s/)[2].to_i }
}

