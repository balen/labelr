<template>
  <sidebar-vue :model="model">
    <template #header v-if="selected">
      <h2>{{ badge_name }} <small>({{ selected.first_name }} {{ selected.last_name }})</small></h2>
      <div>Attending: {{attending_status}}</div>
    </template>
    <template #content v-if="selected">
      <div class="mx-auto" style="width: 400px;">
        <img id="labelImage" :src="preview" />
      </div>
      <div class="d-flex justify-content-between my-3" v-if="model != 'staff'">
        <b-form-checkbox
          v-model="hideCountry" switch inline
        >Do not print Country</b-form-checkbox>
      </div>   
      <div class="d-flex justify-content-between my-3">
        <b-button variant="success" @click="onPrint()">Print</b-button>
        <b-button variant="success" @click="onRefresh()">Refresh</b-button>
      </div>
      <div>
        <dl>
          <dt>Ticket Number</dt>
          <dd class="font-italic ml-2">{{ selected.ticket_number }}</dd>
          <dt>Name</dt>
          <dd class="font-italic ml-2">{{ selected.first_name }} {{ selected.last_name }}</dd>
          <dt v-if="model != 'staff'">Preferred Name</dt>
          <dd class="font-italic ml-2" v-if="model != 'staff'">{{ selected.preferred_name_first }} {{ selected.preferred_name_last }}</dd>
          <dt v-if="model != 'staff'">Badge Name</dt>
          <dd class="font-italic ml-2" v-if="model != 'staff'">{{ selected.badge }}</dd>
          <dt>{{ badge_title_text }}</dt>
          <dd class="font-italic ml-2">{{ selected.badge_title }}</dd>
          <dt>{{ country_text }} </dt>
          <dd class="font-italic ml-2">{{ selected.address_country }}</dd>
        </dl>
      </div>
      <h3 class="mt-4 mb-2">Impressions</h3>
      <div class="row" v-for="impression in selected.impressions">
        <div class="col-6">
          {{ DateTime.fromISO(impression.date_printed).toFormat("DDD, t ZZZZ") }}
        </div>
        <div class="col-6">
          {{ impression.user_name }}
        </div>
      </div>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '@/components/shared/sidebar_vue.vue';
import { modelMixin } from '@/mixins/model.mixin';
import printerMixin from "@/mixins/printer.mixin"
import { DateTime } from 'luxon';

export default {
  name: 'RegistrantSidebar',
  components: {
    SidebarVue
  },
  mixins: [
    printerMixin,
    modelMixin
  ],
  data() {
    return {
      hideCountry: false,
      previewImage: null,
      DateTime
    }
  },
  computed: {
    badge_title_text: function() {
      if (this.model == 'staff') {
        return "Title"
      } else {
        return "Badge Title"
      }
    },
    country_text: function() {
      if (this.model == 'staff') {
        return "Division"
      } else {
        return "Country"
      }
    },
    attending_status: function() {
      if (!this.selected) return "";

      if (this.selected.attending_status == 1) {
        return "Not Attending"
      } else if (this.selected.attending_status == 2) {
        return "In Person"
      } else if (this.selected.attending_status == 3) {
        return "Online"
      } else if (this.selected.attending_status == 4) {
        return "Programme"
      } else if (this.selected.attending_status == 5) {
        return "Finalist"
      } else if (this.selected.attending_status == 6) {
        return "Volunteer"
      } else {
        return "Unknown"
      }
    },
    badge_name: function() {
      if (!this.selected) return "";

      if (this.selected.badge){
        return this.selected.badge
      } else if (this.selected.preferred_name_last || this.selected.preferred_name_first) {
        return `${this.selected.preferred_name_first || ''} ${this.selected.preferred_name_last || ''}`.trim()
      } else {
        return `${this.selected.first_name || ''} ${this.selected.last_name || ''}`.trim()
      }
    },
    badge_content: function() {
      if (!this.selected) return null;

      if (this.model == 'staff') {
        return {
          name: this.badge_name,
          position: this.selected.badge_title,
          division: this.selected.address_country,
        }
      } else {
        return {
          name: this.badge_name,
          number: this.selected.ticket_number,
          country: this.hideCountry ? '' : this.selected.address_country,
          title: this.selected.badge_title
        }
      }
    },
    preview: function () {
      if (this.model == 'staff') {
        this.previewImage = this.generateStaffPreview(this.badge_content);
      } else {
        this.previewImage = this.generatePreview(this.badge_content);
      }
      if (this.previewImage) {
        return "data:image/png;base64," + this.previewImage;
      } else {
        return null;
      }
    }
  },
  methods: {
    onPrint() {
      this.doPrint()
    },
    onRefresh() {
      this.fetchSelected()
    }
  }
}
</script>
