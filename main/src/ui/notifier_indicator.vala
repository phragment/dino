using AppIndicator;
using Gee;
using Gtk;

using Dino.Entities;
using Xmpp;

namespace Dino.Ui {

    public class IndicatorNotifier : NotificationProvider, Object {

        /*
         * "Enable indicator" and "Notify when a new message arrives" have to be turned on
         */

        public signal void conversation_selected(Conversation conversation);

        private HashMap<int, bool> notifications = new HashMap<int, bool>();
        public Indicator indicator { get; set; }

        public IndicatorNotifier(StreamInteractor stream_interactor) {
            var mnemonic = "Dino";
            var icon_name = "im.dino.Dino";
            var category = IndicatorCategory.APPLICATION_STATUS;
            this.indicator = new Indicator(mnemonic, icon_name, category);
            indicator.set_status(IndicatorStatus.ACTIVE);

            // bug?
            //indicator.set_attention_icon_full("mail-unread", "new message");
            //indicator.set_attention_icon("mail-unread");
            //indicator.set_status(IndicatorStatus.ATTENTION);

            var menu = new Gtk.Menu();

            var item2 = new Gtk.MenuItem.with_label("Quit");
            item2.activate.connect(() => {
                Dino.Application.get_default().quit();
            });
            item2.show();
            menu.append(item2);

            indicator.set_menu(menu);
        }

        public double get_priority() {
            return 2;  // only notification provider with highest prio is called
        }

        public void attention() {
            indicator.set_status(IndicatorStatus.ATTENTION);
            indicator.set_icon("mail-unread");
        }

        public void clear() {
            indicator.set_status(IndicatorStatus.ACTIVE);
            indicator.set_icon("im.dino.Dino");
        }

        private async void notify(int id) {
            notifications[id] = true;
            attention();
        }

        private async void unnotify(int id) {
            notifications.remove(id);
            if (notifications.is_empty) {
                clear();
            }
        }

        public async void notify_message(Message message, Conversation conversation, string conversation_display_name, string? participant_display_name) {
            //print("notify message %s\n", conversation.id.to_string());
            notify(conversation.id);
        }

        public async void notify_file(FileTransfer file_transfer, Conversation conversation, bool is_image, string conversation_display_name, string? participant_display_name) {
            //print("notify file %s\n", conversation.id.to_string());
            notify(conversation.id);
        }

        public async void retract_content_item_notifications() {
            //print("retract_content_item_notifications\n");
            unnotify(0);
        }

        public async void retract_conversation_notifications(Conversation conversation) {
            //print("retract_conversation_notifications  %s\n", conversation.id.to_string());
            unnotify(conversation.id);
        }

        public async void notify_call(Call call, Conversation conversation, bool video, string conversation_display_name) {
            //print("notify_call\n");
            // TODO stack on top
            //notify();
        }

        private async void retract_call_notification(Call call, Conversation conversation) {
            //print("retract_call_notification\n");
            //unnotify();
        }

        public async void notify_subscription_request(Conversation conversation) {
            //print("notify_subscription_request\n");
            notify(conversation.id);
        }

        public async void notify_connection_error(Account account, ConnectionManager.ConnectionError error) {
            //print("notify_connection_error\n");
            // TODO stack on top
            //notify();
        }

        public async void notify_muc_invite(Account account, Jid room_jid, Jid from_jid, string inviter_display_name) {
            //print("notify_muc_invite\n");
            //notify();
        }

        public async void notify_voice_request(Conversation conversation, Jid from_jid) {
            //print("notify_voice_request\n");
            notify(conversation.id);
        }
    }
}
