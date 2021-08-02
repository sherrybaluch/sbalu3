<template>
  <q-page class="bg-grey-3 column">
  <div class="row q-pa-sm bg-primary">
        <q-input filled @keyup.enter="addUser" v-model="username" Placeholder="Name"  maxlength="12" dense bg-color="white" class="col" square>
        <template v-slot:append>
          <q-btn round dense flat @click="addUser" icon="add" />
        </template>
      </q-input> 
  </div>


 <div class="q-pa-md q-gutter-md">
    <q-list bordered separator class="bg-white rounded-borders">
      <q-item-label header>Current Waiting Queue</q-item-label>

      <q-item 
	v-for="user in ActiveUsernames"
        :key="user.id"
	clickable v-ripple>
        <q-item-section avatar>
          <q-avatar>
            <img src="~assets/generic_avatar.png">
          </q-avatar>
        </q-item-section>

        <q-item-section>
          <q-item-label lines="1">{{ user.name }}</q-item-label>
          <q-item-label caption lines="2">
	  Reason
          </q-item-label>

        </q-item-section>

        <q-item-section side top>
          <DateDiff :date="new Date(user.timestamp)" />
        </q-item-section>
        <q-btn color="primary" label="Cancel" @click="Cancel(user)"/>          

      </q-item>

    </q-list>
</div>

  </q-page>
</template>

<script>
import DateDiff from 'components/DateDiff.vue'
import { date } from 'quasar'
import db from 'boot/firebase'
export default {
  components: {
    DateDiff
  },
 data() {
return{
username: '',
usernames: [],
}
},
methods: {
async initialize()
{
await db.collection('waiting_details').orderBy("timestamp", "asc").onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if (change.type === 'added') {
            //ADD
	    const source = change.doc.metadata.hasPendingWrites ? 'Local' : 'Server'

            if (source === 'Server') {
				let user = change.doc.data();
				user.id = change.doc.id;
				this.usernames.push(user);
              }
	    }

	    if (change.type === 'modified') {
              //UPDATE
      const index = this.usernames.findIndex(item => item.id == change.doc.id)
				let user = change.doc.data();
				user.id = change.doc.id;
	    			this.usernames.splice(index, 1, user)
            }

	    if (change.type === 'removed') {
              //REMOVE
      const index = this.usernames.findIndex(item => item.id == change.doc.id)
      if (index >= 0) {
	     this.usernames.splice(index, 1)
             }
	}

          })
        })
},
async Cancel(u){
  u.active = false
  // Update back end db
  await db.collection('waiting_details').doc(u.id).update({active: false})
  .then()
  .catch((error) => {})
},

async addUser() {
let newuser = {
name: this.username,
active: true,
timestamp: Date.now()
} 
this.usernames.push(newuser)
await db.collection('waiting_details').add(newuser).then()
.catch((error) => {
                    })
},
computeTimeDiff(date1) {
let date2 = Date.now()
return date.getDateDiff(date2, date1, 'minutes')
},
},
computed: {
ActiveUsernames: function () {
return this.usernames.filter(status => status.active == true)
  }
},
created() {
this.initialize();
},
}
</script>
